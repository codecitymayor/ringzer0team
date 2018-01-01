<#
Preamble:
My goal for this challenge was to attempt something that I, at least, thought was fairly unique in that I used PowerShell and Internet Explorer.
The idea is to instantiate IE as a ComObject and utilize PowerShell to obtain the flag data.
There are some PowerShell-ism language; for instance, I used 'New-Object' to instantiate a selected object. However, most of this talks directly to .NET.

Details:
Through this process, I was unable to push credentials to the site agnostic to the browser out of lack of knowlege and practice.
So, I brought up an IE window and called for the actual URL, but was presented with a login page. To keep track of this, I used a very simple 'While' loop.
The loop checked for the first string I figured was unique to the page. Upon seeing this string, a true flag gets set and the script moves on.
Then, I split the given HTML string into an array by calling the Split() method on a line-break character.
Next, I searched through the array for a match on "----- Begin Message -----" and set the variable $string to the next indexed value.
It was then important to rid $string of any white space, line-breaks and the '<br>' at the end of the string using the Replace() method from the System.String object.
Next, I had to instantiate the SHA512 object in order to perform the hash.
However, the GetHash() method requires data in a byte stream; so, I had to use the GetBytes() method from the UTF8Encoding class and feed that into the ComputeHash() method.
Finally, I needed to get rid of the '-' in the string and ensure the Hex was in lower-case in order to send back to the browser as a URL. 

Shortfalls:
1.) I had to use IE, because I did not know how to communicate directly with the website using .NET.
2.) I had to use IE.
3.) Because of this, I could not get the flag and submit it.
4.) I am still learning.
#>

$flag=$false;$string=$null;$hash=$null;$searchArray=$null
$ie=New-Object -ComObject InternetExplorer.Application
$ie.Visible=$true
$ie.navigate("https://ringzer0team.com/challenges/13")
while($flag -ne $true){If($ie.Document.documentElement.outerHTML -match "Hash me if you can"){$flag=$true}}
$searchArray=$ie.document.documentElement.outerHTML.split("`n")
for($i=0;$i -lt $searchArray.Length;$i++){If($searchArray[$i] -match "----- Begin Message -----"){[string]$string=$searchArray[$i+1]}}
$string=$string.replace("<br>","").Replace("`t","").Replace(" ","").Replace("`n","")
$hString=New-Object System.Text.UTF8Encoding
$alg=New-Object System.Security.Cryptography.SHA512Managed
$hash=([System.BitConverter]::ToString($alg.ComputeHash($hString.GetBytes($string)))).Replace("-","").ToLower()
$ie.Navigate("https://ringzer0team.com/challenges/13/$hash")
