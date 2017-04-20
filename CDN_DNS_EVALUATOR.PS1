Clear
# PUBLIC VARIABLES 
# RESOLVERS IS A TUPLE CONTAINING THE NAME AND IP ADDRESS. LIST COMES FROM https://www.lifewire.com/free-and-public-dns-servers-2626062
# looping through tuples: http://stackoverflow.com/questions/9015138/powershell-looping-through-a-hash-or-using-an-array
#currently 14 Resolvers

$RESOLVERS = @{Level3="209.244.0.3";Verisign="64.6.64.6";Google3="8.8.8.8";DNSWATCH="84.200.69.80";ComodoSecureDNS="8.26.56.26";OpenDNS="208.67.222.222";NortonConnectSafe="199.85.126.10";SafeDNS="195.46.39.39";OpenNIC="96.90.175.167";Dyn="216.146.35.35";FreeDNS="37.235.1.174";AlternateDNS="198.101.242.72";YandexDNS="77.88.8.8";UncensoredDNS="91.239.100.100"}
$LogTime = Get-Date
$LogDay = Get-Date -Format "dd-MM-yyyy"
$LogFile = 'C:\'+"LOG_"+$LogDay+".log"
$Domain = "acme-v01.api.letsencrypt.org"
$SSLPort=443


foreach($resolver in $RESOLVERS.Keys){

#Write-Host ${resolver}
#Write-Host  $($RESOLVERS.Item($resolver))

#create a separator for each record so easy for Data Analytics Solution to break up
#add metadata - log time and the resolver

"<<<<<<<<>>>>>>>>>>>>" | Out-File $LogFile -Append
"Log Time:" + $LogTime | Out-File $LogFile -Append
"Resolver:" + ${resolver} | Out-File $LogFile -Append

#resolve the address using a specific resolver 
#raw saves having to make two DNS calls. WE get one variable and then use filters to get info we want

$RAW =  Resolve-DnsName -NoHostsFile -Type A -Name $Domain -Server $($RESOLVERS.Item($resolver))

#extract IP and log it as metadata (easier for Data Analytics Solution - no need for fancy REGEX)

    $IP = $RAW | Where-Object {$_.IP4Address -ne $null} | Select-Object -Property IP4Address | Select -First 1
    "Resolved IP: " + $IP.IP4Address | Out-File $LogFile -Append
   
    $TcpClient = New-Object -TypeName System.Net.Sockets.TcpClient

#SSL and TCP Check

try{
$TcpClient.Connect($IP.IP4Address, $SSLPort)
$TcpStream = $TcpClient.GetStream()
$Callback = { param($sender, $cert, $chain, $errors) return $true }
$SslStream = New-Object -TypeName System.Net.Security.SslStream -ArgumentList @($TcpStream, $true, $Callback)

    try{
        $SslStream.AuthenticateAsClient('')
        $Certificate = $SslStream.RemoteCertificate
        "Connectivity Check: Passed" | Out-File $LogFile -Append
    }

    catch{
    "Connectivity Check: Falied at SSL" | Out-File $LogFile -Append
    }

    finally{
    $SslStream.Dispose()
    }

}

catch{
"Connectivity Check: Falied at TCP Connections" | Out-File $LogFile -Append
}

finally{
$TcpClient.Dispose()
}


#Log extensive DNS records - insights around TTL and other aspects

$LOGDATA = $RAW |Select -First 3 | Out-File $LogFile -Append

#sleep for 5 seconds - let file be written out accurately 

Start-Sleep -Seconds 5


}
