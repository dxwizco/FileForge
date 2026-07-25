param([string]$Path, [string]$FileName)
return @"
using System;

namespace Project
{
    public class ${FileName}
    {
        public static void Main(string[] args)
        {
            Console.WriteLine("Hello from ${FileName}!");
        }
    }
}
"@