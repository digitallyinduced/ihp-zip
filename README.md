# Support for making ZIP Archives with IHP

## Install


1. Add `ihp-zip` and `zip-archive` to the `haskellDeps` in your `default.nix`:
    ```nix
    let
        ...
        haskellEnv = import "${ihp}/NixSupport/default.nix" {
            ihp = ihp;
            haskellDeps = p: with p; [
                # ...
                ihp-zip
                zip-archive
            ];
        ...
    ```
2. Run `make -B .envrc`
3. Add `IHP.Zip.ControllerFunctions` to your `Web.Controller.Prelude`:
    ```haskell
    module Web.Controller.Prelude
    ( module Web.Types
    , module Application.Helper.Controller
    , module IHP.ControllerPrelude
    , module Generated.Types
    , module IHP.Zip.ControllerFunctions -- <------- ADD THIS EXPORT
    )
    where

    import Web.Types
    import Application.Helper.Controller
    import IHP.ControllerPrelude
    import Generated.Types
    import IHP.Zip.ControllerFunctions -- <----- ADD THIS IMPORT
    ```
## Usage

In your action use it like this:

```haskell
module Web.Controller.Users where

import Web.Controller.Prelude

import qualified Codec.Archive.Zip as Zip

instance Controller UsersController where
    action ExportAction = do
        archive <- ["FileA", "FileB"]
                |> Zip.addFilesToArchive [] Zip.emptyArchive

        renderZip "Export.zip" archive
````
