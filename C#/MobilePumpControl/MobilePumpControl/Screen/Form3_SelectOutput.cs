using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using MobilePumpControl.Screen;
using MobilePumpControl.ScopeDatas;

namespace MobilePumpControl.Screen
{
    public partial class Form3_SelectOutput : Form
    {

        private double[] signaloutput;
        private double[] signalInput;

        public Form3_SelectOutput(double[] sigInp)
        {
            InitializeComponent();
            this.signalInput = sigInp;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            Form formMain = new Form4_Main();
            formMain.Show();  
        }

        private void button2_Click(object sender, EventArgs e)
        {
            this.signaloutput = SignalsImporter.importSignal(@"C:\Users\Flavio\Documents\GitHub\MobilePumpControl\C#\MobilePumpControl\MobilePumpControl\ScopeDatas\signal1.txt");
            Console.WriteLine("The size of Signal 1 is" + signaloutput.Length);
            buttonOutputNext.Enabled = true;
        }

        private void button3_Click(object sender, EventArgs e)
        {
            this.signaloutput = SignalsImporter.importSignal(@"C:\Users\Flavio\Documents\GitHub\MobilePumpControl\C#\MobilePumpControl\MobilePumpControl\ScopeDatas\signal4.txt");
            Console.WriteLine("The size of Signal 4 is" + signaloutput.Length);
            buttonOutputNext.Enabled = true;
        }
    }
}

