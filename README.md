# CND-DNS-EVALUATION
A PowerShell Script for collecting data for Evaluation of CDN's DNS Decisions. Uses a range of resolvers to get a better understanding. 

Schedule the script to run every 15 minutes or less. Not more often the 5 minutes. This is because the script sleeps for 5 seconds between each resolver so takes 2-3 minutes to run through each iteration. 

Records are in the format below to make it easier to parse with BigData Tools such as Splunk or ELK Stack. 

<<<<<<<<>>>>>>>>>>>>
Log Time:04/19/2017 00:00:16
Resolver:SafeDNS
Resolved IP: 173.223.230.11
Connectivity Check: Passed

Name                           Type   TTL   Section    NameHost                                                        
----                           ----   ---   -------    --------                                                        
acme-v01.api.letsencrypt.org   CNAME  6300  Answer     api.letsencrypt.org.edgekey.net                                 
api.letsencrypt.org.edgekey.ne CNAME  6300  Answer     e981.dscb.akamaiedge.net                                        
t                                                                                                                      

Name       : e981.dscb.akamaiedge.net
QueryType  : A
TTL        : 20
Section    : Answer
IP4Address : 173.223.230.11


