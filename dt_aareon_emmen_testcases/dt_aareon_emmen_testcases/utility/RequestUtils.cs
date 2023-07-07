namespace dt_aareon_emmen_testcases.utility;

using System;
using System.Collections.Generic;
using System.Collections.Specialized;

using System.Net;
using System.Net.Http;
using System.Reflection.PortableExecutable;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using HtmlAgilityPack;

public class RequestUtils
{
    // send a POST request with formdata, return the response
    public static HttpWebResponse SendHttpPostRequest(string url, string postData, Dictionary<string, string> headers, bool redirect)
    {
        // Ignore certificate errors
        ServicePointManager.ServerCertificateValidationCallback += (sender, cert, chain, sslPolicyErrors) => true;

        // Create the HTTP request
        HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
        request.Method = "POST";
        request.AllowAutoRedirect = redirect;

        // Set the request body (post data)
        byte[] data = Encoding.ASCII.GetBytes(postData);
        request.ContentLength = data.Length;
        using (var stream = request.GetRequestStream())
        {
            stream.Write(data, 0, data.Length);
        }


        // Add headers
        if (headers != null)
        {
            foreach (var h in headers)
            {
                request.Headers.Add(h.Key, h.Value);
            }
        }

        // Get the HTTP response
        HttpWebResponse response = (HttpWebResponse)request.GetResponse();
        return response;
    }

    // send a POST request with formdata, return the response
    //public static HttpWebResponse SendHttpPostRequestWithImages(string url, Dictionary<String, String> postData, Dictionary<string, string> headers, Dictionary<string, byte[]> images, bool redirect)
    //{
    //    // Ignore certificate errors
    //    ServicePointManager.ServerCertificateValidationCallback += (sender, cert, chain, sslPolicyErrors) => true;

    //    // Create the HTTP request
    //    HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
    //    request.Method = "POST";
    //    request.AllowAutoRedirect = redirect;
    //    string boundary = "----WebKitFormBoundaryANKYL5Ar8UWvsUY";

    //    // Set the request body (post data and images)
    //    using (var stream = request.GetRequestStream())
    //    {
    //        // Write the form data
    //        foreach (var field in postData)
    //        {
    //            stream.Write(Encoding.ASCII.GetBytes(boundary));
    //            stream.Write(Encoding.ASCII.GetBytes($"Content-Disposition: form-data; name='{field.Key}'"));
    //            stream.Write(Encoding.ASCII.GetBytes(field.Value));
    //        }

    //        // Write the images
    //        if (images != null && images.Count > 0)
    //        {
    //            foreach (var image in images)
    //            {
    //                string fileName = image.Key;
    //                byte[] imageData = image.Value;

    //                stream.Write(Encoding.ASCII.GetBytes(boundary));
    //                stream.Write(Encoding.ASCII.GetBytes($"Content-Disposition: form-data; name=\"{fileName}\"; filename=\"{fileName}.jpg\""));
    //                stream.Write(Encoding.ASCII.GetBytes("Content-Type: image/jpeg"));
    //                stream.Write(imageData, 0, imageData.Length);
    //            }
    //        }

    //        // Write the closing boundary
    //        stream.Write(Encoding.ASCII.GetBytes(boundary));
    //    }

    //    // Add headers
    //    if (headers != null)
    //    {
    //        foreach (var h in headers)
    //        {
    //            request.Headers.Add(h.Key, h.Value);
    //        }
    //    }

    //    // Get the HTTP response
    //    HttpWebResponse response = (HttpWebResponse)request.GetResponse();
    //    return response;
    //}


    public static HttpWebResponse SendHttpPostRequestWithImages(string url, Dictionary<string, string> postData, Dictionary<string, string> headers, Dictionary<string, byte[]> images, bool redirect)
    {
        // Ignore certificate errors
        ServicePointManager.ServerCertificateValidationCallback += (sender, cert, chain, sslPolicyErrors) => true;

        // Create the HTTP request
        HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
        request.Method = "POST";
        request.AllowAutoRedirect = redirect;
        string boundary = "----WebKitFormBoundaryANKYL5Ar8UWvsUY";

        // Set the request body (post data and images)
        using (var stream = request.GetRequestStream())
        {
            // Write the form data
            foreach (var field in postData)
            {
                PrintFormData(stream, field.Key, field.Value, boundary);
            }

            // Write the images
            if (images != null && images.Count > 0)
            {
                foreach (var image in images)
                {
                    string fileName = image.Key;
                    byte[] imageData = image.Value;

                    PrintImage(stream, fileName, imageData, boundary);
                }
            }

            // Write the closing boundary
            WriteBoundary(stream, boundary);
        }

        // Add headers
        if (headers != null)
        {
            foreach (var h in headers)
            {
                request.Headers.Add(h.Key, h.Value);
                // Print the headers
                Console.WriteLine(h.Key + ": " + h.Value);
            }
        }

        // Print the entire HTTP request
        string httpRequest = request.Method + " " + request.RequestUri + " HTTP/1.1\r\n" + request.Headers.ToString();
        Console.WriteLine(httpRequest);

        // Get the HTTP response
        HttpWebResponse response = (HttpWebResponse)request.GetResponse();
        return response;
    }

    // Remaining code for PrintFormData, PrintImage, and WriteBoundary functions remains the same as the previous response.


    private static void PrintFormData(Stream stream, string fieldName, string fieldValue, string boundary)
    {
        string formData = boundary + "\r\n" +
                          $"Content-Disposition: form-data; name=\"{fieldName}\"\r\n\r\n" +
                          fieldValue + "\r\n";
        byte[] formDataBytes = Encoding.ASCII.GetBytes(formData);
        stream.Write(formDataBytes, 0, formDataBytes.Length);

        // Print the form data
        Console.WriteLine(formData);
    }

    private static void PrintImage(Stream stream, string fieldName, byte[] imageData, string boundary)
    {
        string imageHeader = boundary + "\r\n" +
                             $"Content-Disposition: form-data; name=\"{fieldName}\"; filename=\"{fieldName}.jpg\"\r\n" +
                             "Content-Type: image/jpeg\r\n\r\n";
        byte[] imageHeaderBytes = Encoding.ASCII.GetBytes(imageHeader);
        stream.Write(imageHeaderBytes, 0, imageHeaderBytes.Length);

        // Print the image header
        Console.WriteLine(imageHeader);

        // Print the image data (in base64 for readability)
        string imageDataBase64 = Convert.ToBase64String(imageData);
        Console.WriteLine(imageDataBase64);
    }

    private static void WriteBoundary(Stream stream, string boundary)
    {
        string closingBoundary = boundary + "--\r\n";
        byte[] closingBoundaryBytes = Encoding.ASCII.GetBytes(closingBoundary);
        stream.Write(closingBoundaryBytes, 0, closingBoundaryBytes.Length);

        // Print the closing boundary
        Console.WriteLine(closingBoundary);
    }

    // send a GET request, return the response
    public static HttpWebResponse SendHttpGetRequest(string url, Dictionary<String, String> headers)
    {
        // Ignore certificate errors
        ServicePointManager.ServerCertificateValidationCallback += (sender, cert, chain, sslPolicyErrors) => true;

        // Create the HTTP request
        HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
        request.Method = "GET";

        // add headers
        if (headers != null)
        {
            foreach (var h in headers)
            {
                request.Headers.Add(h.Key, h.Value);
            }
        }

        // Get the HTTP response
        HttpWebResponse response = (HttpWebResponse)request.GetResponse();
        return response;
    }

    // extract the entire httpRequestBody for the HttpWebResponse
    public static String ExtractWebRequestBody(HttpWebResponse response)
    {
        using (StreamReader streamReader = new StreamReader(response.GetResponseStream()))
        {
            return streamReader.ReadToEnd();
        }
    }

    // extract the antiforgery token from the HttpWebResponse html
    public static String ExtractAntiForgeryToken(HttpWebResponse response, String tokenName)
    {
        String content = ExtractWebRequestBody(response);

        HtmlDocument htmlDoc = new HtmlDocument();
        htmlDoc.LoadHtml(content);

        // Find the input element with the name "__RequestVerificationToken"
        HtmlNode inputNode = htmlDoc.DocumentNode.SelectSingleNode($"//input[@name='{tokenName}']");

        if (inputNode != null)
        {
            // Get the value of the input element
            string tokenValue = inputNode.GetAttributeValue("value", "");
            return tokenValue.Trim();
        }
        return null;
    }

    // extracts the "Set-Cookie" header from the HttpWebResponse
    public static String ExtractSetCookies(HttpWebResponse response)
    {
        return response.GetResponseHeader("Set-Cookie");
    }

    // prints all headers from a HttpWebResponse
    public static void PrintHeaders(HttpWebResponse response)
    {
        foreach (var h in response.Headers.AllKeys)
        {
            Console.WriteLine($"{h} : {response.Headers[h]}");
        }
    }

    // checks if 1 or more words are present within the HTML
    public static bool htmlWordCheck(string html, params string[] words)
    {
        // Load the HTML document using HtmlAgilityPack
        var doc = new HtmlDocument();
        doc.LoadHtml(html);

        // Check if any of the words are present in the HTML document
        var nodes = doc.DocumentNode.DescendantsAndSelf();
        foreach (var node in nodes)
        {
            if (node.NodeType == HtmlNodeType.Text)
            {
                string text = node.InnerText;
                foreach (string word in words)
                {
                    if (text.Contains(word, StringComparison.OrdinalIgnoreCase))
                    {
                        return true;
                    }
                }
            }
        }

        return false;
    }
}
