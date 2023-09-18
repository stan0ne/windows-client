function List-Disks {
'list disk' | diskpart |
? { $_ -match 'disk (\d+)\s+online\s+\d+ .?b\s+\d+ [gm]b' } |
% { $matches[1] } 
Update-Disk -Number $matches[1]
}

function List-Partitions($disk) {
"select disk $disk", "list partition" | diskpart |
? { $_ -match 'partition (\d+)' } |
% { $matches[1] }
}

function Extend-Partition($disk, $part) {
"select disk $disk","select partition $part","extend" | diskpart | 
Out-Null
}

List-Disks | % {
$disk = $_
List-Partitions $disk | % {
Extend-Partition $disk $_
}
}
