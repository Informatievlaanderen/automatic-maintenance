#r "paket:
version 7.0.2
framework: net6.0
source https://api.nuget.org/v3/index.json
nuget Be.Vlaanderen.Basisregisters.Build.Pipeline 6.0.3 //"

#load "packages/Be.Vlaanderen.Basisregisters.Build.Pipeline/Content/build-generic.fsx"

open Fake.Core
open Fake.Core.TargetOperators
open Fake.IO
open Fake.IO.FileSystemOperators
open ``Build-generic``

let product = "Basisregisters Vlaanderen"
let copyright = "Copyright (c) Vlaamse overheid"
let company = "Vlaamse overheid"

let dockerRepository = "registries-maintenance"
let assemblyVersionNumber = (sprintf "2.%s")

Target.create "Publish" ignore
Target.create "Containerize" ignore
Target.create "Push" ignore

Target.create "Publish_RebuildIndexes" (fun _ ->
  let filterAllFiles = (fun _ -> true)
  let dockerBuildDirectory = buildDir @@ "RebuildSqlIndexes" @@ "linux"
  Shell.copyDir dockerBuildDirectory ("src" @@ "sql-server" @@  "rebuild-indexes") filterAllFiles
)

Target.create "Containerize_RebuildSqlIndexes" (fun _ -> containerize dockerRepository "RebuildSqlIndexes" "rebuild-sql-indexes")
Target.create "PushContainer_RebuildSqlIndexes" (fun _ -> push dockerRepository "rebuild-sql-indexes")

"NpmInstall"
==> "Clean"
==> "Publish_RebuildIndexes"
==> "Publish"

"Publish"
==> "Containerize_RebuildSqlIndexes"
==> "Containerize"

"Containerize"
==> "DockerLogin"
==> "PushContainer_RebuildSqlIndexes"
==> "Push"

Target.runOrDefault "Containerize"
