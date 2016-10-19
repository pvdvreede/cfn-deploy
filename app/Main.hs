module Main where

import Development.Shake
import Development.Shake.Command
import Development.Shake.FilePath
import Development.Shake.Util


rubyTemplateName :: FilePath -> String
rubyTemplateName = dropExtension . takeFileName


main :: IO ()
main = shakeArgs shakeOptions{shakeFiles="cfn"} $ do

    "cfn//*.json" %> \out -> do
        let cfnDir = "lib" </> rubyTemplateName out
        let cfnTemplate = cfnDir </> rubyTemplateName out <.> "rb"
        files <- getDirectoryFiles cfnDir ["*"]
        need files
        cmd "cfndsl" [cfnTemplate, "--pretty", "-b"] ["--output", out]


    phony "clean" $ do
        putNormal "Cleaning files in cfn..."
        removeFilesAfter "cfn" ["//*"]

    phony "compile" $ do
        templates <- getDirectoryDirs "lib"
        need $ map (\x -> "cfn" </> (rubyTemplateName x) <.> "json") templates

