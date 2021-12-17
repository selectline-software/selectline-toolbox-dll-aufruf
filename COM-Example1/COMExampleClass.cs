using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.IO;

namespace COMClassLibrary
{
    [ComVisible(true)] 
    [Guid("2945B34B-1B63-4a58-B5FE-9627FEFAEA9D")]
    [InterfaceType(ComInterfaceType.InterfaceIsDual)]    
    public interface IExampleInterface
    {                
        void Call();

        void CallMsg(Object Msg);

        void CallParams(Object names, Object values);

        void CallDBParams(Object kind, Object names, Object values);        
    }

    [ComVisible(true)]
    [Guid("16E6BC94-308C-4952-84E6-109041990EF7")]
    [ProgId("SelectLine.COMDemo1")]
    [ClassInterface(ClassInterfaceType.None)]
    public class COMExampleClass : IExampleInterface
    {        
        public COMExampleClass()
        {
        }

        ~COMExampleClass()
        {
        }

        public void Call()
        {
            File.WriteAllText(@"d:\Call.txt", $"{DateTime.Now.ToString()} - Simple Call");
        }


        public void CallMsg(Object Msg)
        {
            File.WriteAllText(@"d:\CallMsg.txt", $"{DateTime.Now.ToString()} - CallMsg - Msg:{Msg}");
        }

        public void CallParams(Object names, Object values)
        {
            List<String> lines = new List<string>();
            lines.Add("names:");
            if (names is Object[])
            {
                lines = lines.Concat(ObjectAsStringList(names as Object[])).ToList();
            }

            lines.Add("values:");
            if (values is Object[])
            {
                lines = lines.Concat(ObjectAsStringList(values as Object[])).ToList();
            }

            File.WriteAllLines(@"d:\CallParams.txt", lines);
        }

        public void CallDBParams(Object kind, Object names, Object values)
        {
            List<String> lines = new List<string>();
            lines.Add("kind:");
            if (kind is Object[])
            {
                lines = lines.Concat(ObjectAsStringList(kind as Object[])).ToList();
            }
            lines.Add("names:");
            if (names is Object[])
            {
                lines = lines.Concat(ObjectAsStringList(names as Object[])).ToList();
            }

            lines.Add("values:");
            if (values is Object[])
            {
                lines = lines.Concat(ObjectAsStringList(values as Object[])).ToList();
            }
            File.WriteAllLines(@"d:\CallDBParams.txt", lines);
        }

        private List<String> ObjectAsStringList(Object[] values)
        {
            List<String> returnList = new List<String>();
            foreach (Object item in values)
            {
                returnList.Add(item.ToString());
            }
            return returnList;
        }

    }
}
