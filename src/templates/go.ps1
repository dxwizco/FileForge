param([string]$Path, [string]$FileName)
return @"
package main

import "fmt"

func main() {
	fmt.Println("Hello from ${FileName}!")
}
"@