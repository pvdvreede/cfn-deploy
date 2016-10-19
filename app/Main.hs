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

