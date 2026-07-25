param([string]$Path, [string]$FileName)
return @"
import React from 'react';

export default function ${FileName}() {
  return (
    <div>
      <h1>${FileName} Component</h1>
    </div>
  );
}
"@