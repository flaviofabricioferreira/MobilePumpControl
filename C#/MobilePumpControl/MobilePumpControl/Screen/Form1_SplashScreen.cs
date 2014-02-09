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

namespace MobilePumpControl
{
    public partial class Form1SplahScreen : Form
    {
        public Form1SplahScreen()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

 
        private void button1_Click_1(object sender, EventArgs e)
        {

            //if you want to open form modally 
            //(meaning you can't click on form1 while form2 is open)
            //you can do this: form.showdialog(this);

            //to open form2 non-modally 
            //(meaning you can still click on form1 while form2 is open)
            //you can do this : form.show(this);

            Form formSelectionInput = new Form2InputSelection();
            formSelectionInput.Show();            
        }
    }
}
