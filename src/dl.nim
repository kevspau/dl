import os
import strformat
import terminal

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
  #*ok so basically dividing by 1m instead of this binary number is the standard but im dumb so yea, too lazy to change since changing it makes the .gitignore go crazy with 2e-06 mb???
  var size = $(int(dirs[i].path.getFileInfo().size)/1_048_576)
  echo fmt"      {size.substr(0, 5)} MB" 
  stdout.resetAttributes()