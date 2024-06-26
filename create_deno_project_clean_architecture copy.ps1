
[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $ProjectName,
    
    [Parameter()]
    [string]
    $Path = '.'
)
    


function New-DenoProject {
    param (
        [Parameter(Mandatory = $true)][string]$ProjectName
    )
    # workspace | Out-Null;
    # Set-Location experiments/
    if ($ProjectName -ne '.') {

        mkdir $ProjectName | Set-Location | Out-Null;
    }
    else {
        Write-Host "Creating project in current directory..."
    }
    # Set-Location .\$ProjectName\
    deno init $ProjectName
    New-Item .gitignore | Out-Null;
    New-Item README.md | Out-Null;
    New-Item CHANGELOG.md | Out-Null;
    New-Item deps.ts | Out-Null;
    mkdir docs | Out-Null;
    mkdir config | Out-Null;
    mkdir scripts | Out-Null;
    mkdir src | Set-Location | Out-Null;
    # mkdir src | Out-Null;
    New-AppicationLayer -ProjectName $ProjectName | Out-Null;
    New-DomainLayer -ProjectName $ProjectName | Out-Null;
    New-InfrastructureLayer -ProjectName $ProjectName | Out-Null;
    New-PresentationLayer -ProjectName $ProjectName | Out-Null;
    New-SharedLayer -ProjectName $ProjectName | Out-Null;
    New-TestsLayer -ProjectName $ProjectName | Out-Null;
    Set-Location ..
}

function New-DomainLayer {
    param (
        [string]$ProjectName
    )
    mkdir domain | Out-Null;
    # | Set-Location | Out-Null;
    
    mkdir .\domain\builders | Out-Null;
    mkdir .\domain\entities | Out-Null;
    mkdir .\domain\interfaces | Out-Null;
    mkdir .\domain\value_objects | Out-Null;
    New-Item .\domain\index.ts | Out-Null;
    
    # mkdir builders
    # mkdir entities
    # mkdir interfaces
    # mkdir value_objects
    # New-Item index.ts | Out-Null;
    # Set-Location ..
        
}
    
function New-AppicationLayer {
    param (
        [string]$ProjectName
    )
    mkdir application | Out-Null;
    mkdir .\application\dtos
    mkdir .\application\errors
    mkdir .\application\interfaces
    mkdir .\application\use_cases
    mkdir .\application\common | Out-Null;
    $useCaseBaseFileContent = "interface IUseCase<TInput, TResult> {
    execute(input: TInput): Promise<TResult>;
}

abstract class UseCase<TInput, TOutput> implements IUseCase<TInput, TOutput> {

    abstract execute(input: TInput): Promise<TOutput>
}

export { UseCase };
export  type { IUseCase };" | Out-Null;
    New-Item .\application\common\usecase.ts | Out-Null;
    Set-Content -Path .\application\common\usecase.ts -Value $useCaseBaseFileContent | Out-Null;
    New-Item .\application\index.ts | Out-Null;
    
    # Set-Location ..
            
}
        
function New-InfrastructureLayer {   
    param (
        [string]$ProjectName
    )
    mkdir infrastructure | Out-Null;
    mkdir .\infrastructure\configurations | Out-Null;
    mkdir .\infrastructure\context | Out-Null;
    mkdir .\infrastructure\persistence | Out-Null;
    mkdir .\infrastructure\persistence\repositories | Out-Null;
    mkdir .\infrastructure\services | Out-Null;
    New-Item .\infrastructure\configurations\index.ts | Out-Null;
    New-Item .\infrastructure\context\index.ts | Out-Null;
    New-Item .\infrastructure\persistence\index.ts | Out-Null;
    New-Item .\infrastructure\persistence\repositories\index.ts | Out-Null;
    New-Item .\infrastructure\services\index.ts | Out-Null;
    New-Item .\infrastructure\index.ts | Out-Null;
                
}
            
function New-PresentationLayer {
    param (
        [string]$ProjectName
    )
                    
    mkdir presentation | Out-Null;
    mkdir .\presentation\web | Out-Null;
    mkdir .\presentation\cli | Out-Null;
    mkdir .\presentation\api | Out-Null;
    mkdir .\presentation\workers | Out-Null;
    mkdir .\presentation\errors | Out-Null;
    mkdir .\presentation\serializers\ | Out-Null;
    mkdir .\presentation\common | Out-Null;
    mkdir .\presentation\builders | Out-Null;
    New-Item .\presentation\index.ts | Out-Null;
    New-Item .\presentation\web\index.ts | Out-Null;
    New-Item .\presentation\cli\index.ts | Out-Null;
    New-Item .\presentation\api\index.ts | Out-Null;
    New-Item .\presentation\workers\index.ts | Out-Null;
    New-Item .\presentation\errors\index.ts | Out-Null;
    New-Item .\presentation\serializers\index.ts | Out-Null;
    New-Item .\presentation\common\index.ts | Out-Null;
    New-Item .\presentation\builders\index.ts | Out-Null;
}

function New-SharedLayer {
    param (
        [string]$ProjectName
    )
    mkdir shared | Out-Null;
    mkdir .\shared\logging | Out-Null;
    mkdir .\shared\utils | Out-Null;
    New-Item .\shared\utils\id.generator.ts | Out-Null;
    New-Item .\shared\utils\date.utils.ts | Out-Null;
    New-Item .\shared\logging\logger.ts | Out-Null;
    New-Item .\shared\index.ts | Out-Null;

}

function New-TestsLayer {
    param (
        [string]$ProjectName
    )
    Set-Location .. | Out-Null;
    mkdir tests | Out-Null;
    Move-Item .\main_test.ts tests/ | Out-Null;
    Set-Location .\src | Out-Null;
}

function Test-CommandExists {

    Param ($command)

    $oldPreference = $ErrorActionPreference

    $ErrorActionPreference = ‘stop’

    try { if (Get-Command $command) { RETURN $true } }

    Catch { Write-Host “$command does not exist”; RETURN $false }

    Finally { $ErrorActionPreference = $oldPreference }

} #end function test-CommandExists


if (Test-CommandExists deno) {

    New-DenoProject -ProjectName $ProjectName
}
else {
    Write-Host "You require to install deno, learn more at https://docs.deno.com/runtime/manual/getting_started/installation";
}

