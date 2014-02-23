using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using MobilePumpControl.ControlFunctions;

namespace MobilePumpControl.Screen
{
    public partial class Form4_Main : Form
    {
        public Form4_Main(List<double> signInput, List<double> signOutput)
        {
            InitializeComponent();
            
            ParametersExtractor PE = new ParametersExtractor(signInput, signOutput);

            Console.Clear();
            Console.WriteLine("Parameters Extracted:");
            labelGainK.Text = PE.gainK.ToString();
            Console.WriteLine("Gain K = " + PE.gainK.ToString());
            labelIndexI.Text = PE.nNearTPCV.ToString();
            Console.WriteLine("Index n = " + PE.nNearTPCV.ToString());
            labelTimeT1.Text = PE.timeT1.ToString();
            Console.WriteLine("Time T1 = " + PE.timeT1.ToString());
            labelTimeTt.Text = PE.deadTimeTt.ToString();
            Console.WriteLine("Time DeadTime Tt = " + PE.deadTimeTt.ToString());
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void label4_Click(object sender, EventArgs e)
        {

        }

        private void label5_Click(object sender, EventArgs e)
        {

        }
    }
}
