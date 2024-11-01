#region License
/*
Copyright (c) 2023-2024 Dmitrii Evdokimov
Source https://github.com/diev/

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
#endregion

using System;
using System.Configuration;
using System.IO;
using System.IO.Compression;
using System.Net;
using System.Text;
using System.Xml;
using System.Xml.Xsl;

using Lib;

namespace XslTrans
{
    internal class Program
    {
        static int Main(string[] args)
        {
            try
            {
                if (args.Length == 0 || args[0].Equals("-?"))
                {
                    Usage();
                    return 1;
                }

                string xsltFile = ReadSetting("XsltFile");
                string outPath = ReadSetting("OutPath");
                
                bool batch = !string.IsNullOrEmpty(xsltFile);

                if (batch)
                {
                    if (!File.Exists(xsltFile))
                    {
                        Console.WriteLine($"Translation file '{xsltFile}' (see config) not found.");
                        return 2;
                    }
                }
                else // !batch
                {
                    if (args.Length > 0)
                    {
                        string xmlFile = Path.GetFullPath(args[0]);

                        if (!File.Exists(xmlFile))
                        {
                            Console.WriteLine($"Source file '{xmlFile}' not found.");
                            return 2;
                        }
                    }

                    if (args.Length > 1)
                    {
                        xsltFile = Path.GetFullPath(args[1]);

                        if (!File.Exists(xsltFile))
                        {
                            Console.WriteLine($"Translation file '{xsltFile}' not found.");
                            return 2;
                        }
                    }

                    if (args.Length > 2)
                    {
                        outPath = args[2];
                    }

                    if (args.Length > 3)
                    {
                        Usage();
                        return 1;
                    }
                }

                var xslt = GetXslCompiled(xsltFile);

                if (string.IsNullOrEmpty(outPath))
                {
                    outPath = @".\";
                }

                if (batch)
                {
                    foreach (string file in args)
                    {
                        Worker(file, xslt, outPath);
                    }
                }
                else
                {
                    Worker(args[0], xslt, outPath);
                }

                return 0;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);

                if (ex.InnerException != null)
                {
                    Console.WriteLine(ex.InnerException.Message);
                }

                return 3;
            }
        }

        private static XslCompiledTransform GetXslCompiled(string path)
        {
            // Create the XslCompiledTransform object.
            XslCompiledTransform xslt = new XslCompiledTransform();

            // Create the XsltSettings object with script enabled.
            XsltSettings xsltSettings = new XsltSettings(false, true);

            // Create a resolver and set the default credentials to use.
            XmlUrlResolver xmlResolver = new XmlUrlResolver
            {
                Credentials = CredentialCache.DefaultCredentials
            };

            // Load the style sheet.
            xslt.Load(path, xsltSettings, xmlResolver);

            return xslt;
        }

        private static void Worker(string path, XslCompiledTransform xslt, string outPath)
        {
            if (path.Contains("*") || path.Contains("?"))
            {
                string dir = ".";
                string mask = path;

                if (path.Contains(@"\") || path.Contains("/"))
                {
                    int i = path.LastIndexOfAny(new char[] { '\\', '/' });
                    dir = path.Substring(0, i);
                    mask = path.Substring(i + 1);

                    if (dir == "")
                    {
                        dir = ".";
                    }
                }

                foreach (string file in Directory.EnumerateFiles(dir, mask, SearchOption.TopDirectoryOnly))
                {
                    Worker(file, xslt, outPath);
                }

                return;
            }

            if (path.EndsWith(".zip", StringComparison.OrdinalIgnoreCase))
            {
                string tempDir = Path.Combine(Path.GetTempPath(), Path.GetRandomFileName());
                ZipFile.ExtractToDirectory(path, tempDir);

                foreach (string file in Directory.EnumerateFiles(tempDir, "*.xml", SearchOption.AllDirectories))
                {
                    Worker(file, xslt, outPath);
                }

                Directory.Delete(tempDir, true);
                return;
            }

            // Create a parameter which fills client_id.
            XsltArgumentList xsltArgs = new XsltArgumentList();
            string guid = Guid.NewGuid().ToString();
            xsltArgs.AddParam(nameof(guid), string.Empty, guid);

            // Create the output file name.
            string ext = GetExtension(xslt.OutputSettings.OutputMethod);
            string output = string.IsNullOrEmpty(outPath)
                ? Path.ChangeExtension(path, ext)
                : GetResultName(outPath, path, ext, guid);

            // Create the output XmlSettings.
            XmlWriterSettings writerSettings = xslt.OutputSettings.Clone();
            writerSettings.IndentChars = "  ";
            //writerSettings.Indent = true; //use it in XSLT

            if (xslt.OutputSettings.Encoding == Encoding.UTF8)
            {
                // Remove the BOM!
                writerSettings.Encoding = new UTF8Encoding(false);
            }

            // Create a resolver and set the default credentials to use.
            XmlUrlResolver xmlResolver = new XmlUrlResolver
            {
                Credentials = CredentialCache.DefaultCredentials
            };

            using (XmlReader src = XmlReader.Create(path))
            {
                // Execute the transform and output the results to a file.
                using (XmlWriter result = XmlWriter.Create(output, writerSettings))
                {
                    xslt.Transform(src, xsltArgs, result, xmlResolver);
                    result.Close();
                }

                Console.WriteLine($"Done to '{output}'.");
            }
        }

        private static string ReadSetting(string key)
        {
            var appSettings = ConfigurationManager.AppSettings;
            return appSettings[key] ?? "Not Found";
        }

        private static string GetResultName(string arg, string xmlFile, string ext, string guid)
        {
            string result = Path.GetFullPath(arg);
            string name = Path.GetFileName(xmlFile);

            // dir

            if (Directory.Exists(result))
            {
                return Path.Combine(result, Path.ChangeExtension(name, ext));
            }

            var sep = result[result.Length - 1];

            if (sep == Path.DirectorySeparatorChar || sep == Path.AltDirectorySeparatorChar)
            {
                Directory.CreateDirectory(result);
                return Path.Combine(result, Path.ChangeExtension(name, ext));
            }

            // file

            var fi = new FileInfo(result);
            var di = fi.Directory;
            
            if (fi.Name.Equals("guid", StringComparison.OrdinalIgnoreCase))
            {
                result = Path.Combine(di.FullName, guid + fi.Extension);
            }
            else if (fi.Name.Equals("{guid}", StringComparison.OrdinalIgnoreCase))
            {
                result = Path.Combine(di.FullName, '{' + guid + '}' + fi.Extension);
            }

            if (!di.Exists)
            {
                di.Create();
            }

            return result;
        }

        private static string GetExtension(XmlOutputMethod method)
        {
            switch (method)
            {
                case XmlOutputMethod.Xml: // default in XSLT
                    return "response.xml";

                case XmlOutputMethod.Html:
                    return "html";

                case XmlOutputMethod.Text:
                    return "txt";

                default:
                    //case XmlOutputMethod.AutoDetect:
                    return "auto"; //TODO extension
            }
        }
        private static void Usage()
        {
            string help = @"
Usage 1 on 'xsl:output method' in XSLT:

 - 'xml' : XslTrans Request.xml Xml.xslt [Dir|Request.response.xml]
 - 'xml' : XslTrans Request.xml Xml.xslt [Dir|guid.xml]
 - 'xml' : XslTrans Request.xml Xml.xslt [Dir|{guid}.xml]
 - 'html': XslTrans Request.xml Htm.xslt [Dir|Request.html]
 - 'text': XslTrans Request.xml Txt.xslt [Dir|Request.txt]

If 'Dir', this must exist or use 'Dir\' to create this.
If 'guid.xml'/'{guid}.xml', this will be replaced by a generated guid.

(This guid is autogenerated to use as an unique xsl:param.)

Usage 2 in batch mode (if 'XsltFile' is set in config):
 - XsltFile : Path to a constant XSLT file
 - OutPath  : Same as an optional 'Dir' above

XslTrans File.xml [, ...]
XslTrans Mask?*.xml [, ...]
XslTrans in\X*.zip [, ...]

(You can drag-n-drop some files to process them all.)";

            Console.WriteLine(App.Version);
            Console.WriteLine(App.Description);
            Console.WriteLine(help);
        }
    }
}
