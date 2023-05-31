#region License
/*
Copyright (c) 2023 Dmitrii Evdokimov
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
using System.IO;
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
            if (args.Length < 2 || args.Length > 3)
            {
                Usage();
                return 1;
            }

            string fXml = Path.GetFullPath(args[0]);
            string fXsl = Path.GetFullPath(args[1]);

            if (!File.Exists(fXml))
            {
                Console.WriteLine($"Source file '{fXml}' not found.");
                return 2;
            }

            if (!File.Exists(fXsl))
            {
                Console.WriteLine($"Translation file '{fXsl}' not found.");
                return 2;
            }

            try
            {
                // Create a parameter which fills client_id.
                XsltArgumentList xslArgs = new XsltArgumentList();
                string guid = Guid.NewGuid().ToString();
                xslArgs.AddParam(nameof(guid), string.Empty, guid);

                using (XmlReader src = XmlReader.Create(fXml))
                {
                    // Create the XslCompiledTransform object.
                    XslCompiledTransform xslt = new XslCompiledTransform();

                    // Create the XsltSettings object with script enabled.
                    XsltSettings settings = new XsltSettings(false, true);

                    // Create a resolver and set the default credentials to use.
                    XmlUrlResolver resolver = new XmlUrlResolver
                    {
                        Credentials = CredentialCache.DefaultCredentials
                    };

                    // Load the style sheet.
                    xslt.Load(fXsl, settings, resolver);

                    // Create the output file name.
                    string ext = GetExtension(xslt.OutputSettings.OutputMethod);
                    string fOut = args.Length == 3
                        ? GetResultName(args[2], fXml, ext, guid)
                        : Path.ChangeExtension(fXml, ext);

                    // Create the output XmlSettings.
                    XmlWriterSettings writerSettings = xslt.OutputSettings.Clone();
                    writerSettings.IndentChars = "  ";
                    //writerSettings.Indent = true; //use it in XSLT

                    if (xslt.OutputSettings.Encoding == Encoding.UTF8)
                    {
                        // Remove the BOM!
                        writerSettings.Encoding = new UTF8Encoding(false);
                    }

                    // Execute the transform and output the results to a file.
                    using (XmlWriter result = XmlWriter.Create(fOut, writerSettings))
                    {
                        xslt.Transform(src, xslArgs, result, resolver);
                        result.Close();
                    }

                    Console.WriteLine($"Done to '{fOut}'.");
                }

                return 0;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return 3;
            }
        }

        private static string GetResultName(string arg, string fXml, string ext, string guid)
        {
            string result = Path.GetFullPath(arg);

            if (Directory.Exists(result))
            {
                string fileName = Path.GetFileName(fXml);
                return Path.Combine(result, Path.ChangeExtension(fileName, ext));
            }

            if (result[result.Length - 1] == Path.DirectorySeparatorChar)
            {
                Directory.CreateDirectory(result);
                string fileName = Path.GetFileName(fXml);
                return Path.Combine(result, Path.ChangeExtension(fileName, ext));
            }

            string path = Path.GetDirectoryName(result);
            string name = Path.GetFileNameWithoutExtension(result);

            if (name.Equals("guid", StringComparison.OrdinalIgnoreCase))
            {
                result = Path.Combine(path, guid + Path.GetExtension(result));
            }
            else if (name.Equals("{guid}", StringComparison.OrdinalIgnoreCase))
            {
                result = Path.Combine(path, '{' + guid + '}' + Path.GetExtension(result));
            }

            Directory.CreateDirectory(path);
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
Usage on 'xsl:output method' in XSLT:

 - 'xml' : XslTrans Request.xml Xml.xslt [Dir|Request.response.xml]
 - 'xml' : XslTrans Request.xml Xml.xslt [Dir|guid.xml]
 - 'xml' : XslTrans Request.xml Xml.xslt [Dir|{guid}.xml]
 - 'html': XslTrans Request.xml Htm.xslt [Dir|Request.html]
 - 'text': XslTrans Request.xml Txt.xslt [Dir|Request.txt]

If 'Dir', this must exist or use 'Dir\' to create this.
If 'guid.xml, this will substituted by Guid of 'client_id'.
If '{guid}.xml, this will substituted by {Guid} of 'client_id'.";

            Console.WriteLine(App.Version);
            Console.WriteLine(App.Description);
            Console.WriteLine(help);
        }
    }
}
