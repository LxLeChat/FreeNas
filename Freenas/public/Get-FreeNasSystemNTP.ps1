﻿function Get-FreeNasSystemNTP
{
    [Alias()]
    Param
    ()

    Begin
    {
        if (  $global:SrvFreenas -eq $null -or $global:Session -eq $null)
        {
            Write-Host "Your aren't connected "-ForegroundColor Red
        }

    }
    Process
    {
        $Uri = "http://$global:SrvFreenas/api/v1.0/system/ntpserver/"

        try
        { 
            $result = Invoke-RestMethod -Uri $Uri -WebSession $global:Session -Method Get

        }

        Catch {}

        $FreenasConf = New-Object System.Collections.ArrayList
        for ($i = 0; $i -lt $result.Count; $i++)
        {
            $Name = $result[$i].disk_name
            $temp = New-Object System.Object
            $temp | Add-Member -MemberType NoteProperty -Name "Id" -Value "$($result[$i].id)"
            $temp | Add-Member -MemberType NoteProperty -Name "NTP_Server" -Value "$($result[$i].ntp_address)"
            $temp | Add-Member -MemberType NoteProperty -Name "NTP_Burst" -Value "$($result[$i].ntp_burst)"
            $temp | Add-Member -MemberType NoteProperty -Name "NTP_iBurst" -Value "$($result[$i].ntp_iburst)"
            $temp | Add-Member -MemberType NoteProperty -Name "NTP_Max_Poll" -Value "$($result[$i].ntp_maxpoll)"
            $temp | Add-Member -MemberType NoteProperty -Name "NTP_Prefrer" -Value "$($result[$i].ntp_prefer)"
            $FreenasConf.Add($temp) | Out-Null
        }

        return $FreenasConf | FT

    }
    End {}
}
