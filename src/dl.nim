import os
import strformat
import terminal
import strutils

type comp = object
  name: string
  dir: bool
  exec: bool
  sym: bool
  path: string

var dirs: seq[comp]


for k, p in walkDir(getCurrentDir()):
  dirs.add(comp(name: splitFile(p).name & splitFile(p).ext, dir: if k == pcDir: true else: false, exec: if fpUserExec in p.getFilePermissions(): true else: false, sym: if k == pcLinkToDir or k == pcLinkToFile: true else: false, path: p))

for i in 0..dirs.len - 1:
  var name = dirs[i].name
  var s = "B"
  stdout.setForegroundColor(fgCyan)
  stdout.write("\u2506- ")
  stdout.resetAttributes()
  if dirs[i].exec: 
    stdout.setStyle({styleItalic})
    stdout.setForegroundColor(fgGreen)
  if dirs[i].dir: 
    stdout.setForegroundColor(fgBlue)
    name = name & "/"
  if dirs[i].sym:
    name = name & "*"
  stdout.write(name)
  stdout.resetAttributes()
  stdout.setForegroundColor(fgYellow)

  let osize = dirs[i].path.getFileInfo().size.int
  var size: float
  #sets size and type
  if osize >= 1_048_576:
    size = osize/1_048_576
    s = "MB"
  elif osize >= 1_024:
    size = osize/1_024
    s = "kB"
  else:
    size = osize.float
    s = "B"
  #if the length of the size, not including .s, is bigger than 5, then shorten it
  let l = replace($size,".", "").len
  var final: string
  if l > 5:
    final = substr($size, 0, 5)
  else:
    final = $size
  echo fmt"      {final} {s}" 
  stdout.resetAttributes()