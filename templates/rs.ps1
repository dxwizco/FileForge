param([string]$Path, [string]$FileName)
return @"
fn main() {
    println!("Hello from ${FileName}!");
}
"@