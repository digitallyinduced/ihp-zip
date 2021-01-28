module IHP.Zip.ControllerFunctions
( renderZip
, renderZipUnnamed
) where

import IHP.Prelude
import IHP.Controller.Context
import IHP.ControllerSupport
import Network.Wai
import Network.HTTP.Types

import qualified Codec.Archive.Zip as Zip

-- | Sends a ZIP Archive to be downloaded by the browser. The downloaded file will be named after the given file name.
--
-- __Example:__
--
-- > import IHP.Zip.ControllerFunctions
-- > import qualified Codec.Archive.Zip as Zip
-- >
-- > action ExportAction = do
-- >     zipArchive <- ["FileA.txt", "FileB.txt"]
-- >         |> Zip.addFilesToArchive [] Zip.emptyArchive
-- >
-- >     renderZip "Export.zip" archive
--
--
-- If you don't care about the downloaded file name, use 'renderZipUnnamed'.
--
-- See https://hackage.haskell.org/package/zip-archive-0.4.1/docs/Codec-Archive-Zip.html for full reference of how build a zip archive
renderZip :: (?context :: ControllerContext) => Text -> Zip.Archive -> IO ()
renderZip filename archive = respondAndExit $ responseLBS status200 headers (archive |> Zip.fromArchive)
    where
        contentType = (hContentType, "application/zip")
        contentDisposition = (hContentDisposition, "attachment; filename=\"" <> cs filename <> "\"")

        headers :: ResponseHeaders
        headers = [ contentType, contentDisposition ]

-- | Sends a ZIP Archive to be downloaded by the browser.
--
-- __Example:__
--
-- > import IHP.Zip.ControllerFunctions
-- > import qualified Codec.Archive.Zip as Zip
-- >
-- > action ExportAction = do
-- >     zipArchive <- ["FileA.txt", "FileB.txt"]
-- >         |> Zip.addFilesToArchive [] Zip.emptyArchive
-- >
-- >     renderZipUnnamed archive
--
-- To name the downloaded file, use 'renderZip'.
--
-- See https://hackage.haskell.org/package/zip-archive-0.4.1/docs/Codec-Archive-Zip.html for full reference of how build a zip archive
renderZipUnnamed :: (?context :: ControllerContext) => Zip.Archive -> IO ()
renderZipUnnamed archive = respondAndExit $ responseLBS status200 headers (archive |> Zip.fromArchive)
    where
        contentType = (hContentType, "application/zip")
        contentDisposition = (hContentDisposition, "attachment;")

        headers :: ResponseHeaders
        headers = [ contentType, contentDisposition ]

hContentDisposition = "Content-Disposition"