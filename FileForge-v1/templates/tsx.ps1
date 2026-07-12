param(
    [string]$Path,
    [string]$FileName
)


@"
type ${FileName}Props = {};

export default function $FileName({}: ${FileName}Props) {

    return (
        <div>
            $FileName
        </div>
    );
}
"@