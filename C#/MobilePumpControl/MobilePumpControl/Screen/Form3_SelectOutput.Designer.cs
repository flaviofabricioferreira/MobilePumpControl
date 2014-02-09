namespace MobilePumpControl.Screen
{
    partial class Form3_SelectOutput
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.buttonOutputNext = new System.Windows.Forms.Button();
            this.button2 = new System.Windows.Forms.Button();
            this.button3 = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // buttonOutputNext
            // 
            this.buttonOutputNext.Enabled = false;
            this.buttonOutputNext.Location = new System.Drawing.Point(197, 226);
            this.buttonOutputNext.Name = "buttonOutputNext";
            this.buttonOutputNext.Size = new System.Drawing.Size(75, 23);
            this.buttonOutputNext.TabIndex = 0;
            this.buttonOutputNext.Text = "Next";
            this.buttonOutputNext.UseVisualStyleBackColor = true;
            this.buttonOutputNext.Click += new System.EventHandler(this.button1_Click);
            // 
            // button2
            // 
            this.button2.Location = new System.Drawing.Point(31, 38);
            this.button2.Name = "button2";
            this.button2.Size = new System.Drawing.Size(141, 23);
            this.button2.TabIndex = 1;
            this.button2.Text = "Importar Sinal 1";
            this.button2.UseVisualStyleBackColor = true;
            this.button2.Click += new System.EventHandler(this.button2_Click);
            // 
            // button3
            // 
            this.button3.Location = new System.Drawing.Point(31, 81);
            this.button3.Name = "button3";
            this.button3.Size = new System.Drawing.Size(141, 23);
            this.button3.TabIndex = 2;
            this.button3.Text = "Importar Sinal 4";
            this.button3.UseVisualStyleBackColor = true;
            this.button3.Click += new System.EventHandler(this.button3_Click);
            // 
            // Form3_SelectOutput
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(284, 261);
            this.Controls.Add(this.button3);
            this.Controls.Add(this.button2);
            this.Controls.Add(this.buttonOutputNext);
            this.Name = "Form3_SelectOutput";
            this.Text = "Output Signal Selection";
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button buttonOutputNext;
        private System.Windows.Forms.Button button2;
        private System.Windows.Forms.Button button3;
    }
}