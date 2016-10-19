module Main where

import Development.Shake
import Development.Shake.Command
import Development.Shake.FilePath
import Development.Shake.Util

templateDir = "templates"
cfnDir = "cfn"

rubyTemplateName :: FilePath -> String
rubyTemplateName = dropExtension . takeFileName


main :: IO ()
main = shakeArgs shakeOptions{shakeFiles=cfnDir} $ do

    cfnDir ++ "//*.json" %> \out -> do
        let cfnDir = templateDir </> rubyTemplateName out
        let cfnTemplate = cfnDir </> rubyTemplateName out <.> "rb"
        files <- getDirectoryFiles cfnDir ["*"]
        need files
        cmd "cfndsl" [cfnTemplate, "--pretty", "-b"] ["--output", out]


    phony "clean" $ do
        putNormal "Cleaning files in cfn..."
        removeFilesAfter cfnDir ["//*"]

    phony "compile" $ do
        templates <- getDirectoryDirs templateDir
        need $ map (\x -> cfnDir </> (rubyTemplateName x) <.> "json") templates

    -- TODO: Add help task that will list all the template and param commands
    -- TODO: Add init task to create the docker-compose.yml file automatically
    -- TODO: Add create task to setup a new template file structure
