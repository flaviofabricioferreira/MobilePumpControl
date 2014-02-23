using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using MobilePumpControl.ScopeDatas;
using MobilePumpControl.Screen;

namespace MobilePumpControl.Screen
{
    public partial class Form2InputSelection : Form
    {
        
        List<double> signalInput;

        public Form2InputSelection()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            this.signalInput = SignalsImporter.importSignal(@"C:\Users\Flavio\Documents\GitHub\MobilePumpControl\C#\MobilePumpControl\MobilePumpControl\ScopeDatas\signal2.txt");
            Console.WriteLine("The size of Signal 2 is" + signalInput.Count);
            buttonInputNext.Enabled = true;
        }

        private void button5_Click(object sender, EventArgs e)
        {
            Form formOutputSelection = new Form3_SelectOutput(this.signalInput);
            formOutputSelection.Show();  
        }
    }
}
