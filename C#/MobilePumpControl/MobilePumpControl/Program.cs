using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace MobilePumpControl
{
    static class Program
    {
        /// <summary>
        /// 
        /// 
        /// 
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            
            //AUmento do buffer do console para testes
            Console.BufferHeight = 1000;
            Console.BufferWidth = 100;


            Application.Run(new Form1SplahScreen());
        }
    }
}

