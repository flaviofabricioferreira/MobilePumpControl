namespace MobilePumpControl.Screen
{
    partial class Form4_Main
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
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.labelGainK = new System.Windows.Forms.Label();
            this.labelTimeT1 = new System.Windows.Forms.Label();
            this.labelTimeTt = new System.Windows.Forms.Label();
            this.labelIndexI = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(25, 18);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(39, 13);
            this.label1.TabIndex = 0;
            this.label1.Text = "Gain K";
            this.label1.Click += new System.EventHandler(this.label1_Click);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(25, 52);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(46, 13);
            this.label2.TabIndex = 1;
            this.label2.Text = "Time T1";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(25, 86);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(40, 13);
            this.label3.TabIndex = 2;
            this.label3.Text = "TimeTt";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(28, 124);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(36, 13);
            this.label4.TabIndex = 3;
            this.label4.Text = "IndexI";
            this.label4.Click += new System.EventHandler(this.label4_Click);
            // 
            // labelGainK
            // 
            this.labelGainK.AutoSize = true;
            this.labelGainK.Location = new System.Drawing.Point(89, 18);
            this.labelGainK.Name = "labelGainK";
            this.labelGainK.Size = new System.Drawing.Size(13, 13);
            this.labelGainK.TabIndex = 4;
            this.labelGainK.Text = "0";
            this.labelGainK.Click += new System.EventHandler(this.label5_Click);
            // 
            // labelTimeT1
            // 
            this.labelTimeT1.AutoSize = true;
            this.labelTimeT1.Location = new System.Drawing.Point(92, 52);
            this.labelTimeT1.Name = "labelTimeT1";
            this.labelTimeT1.Size = new System.Drawing.Size(13, 13);
            this.labelTimeT1.TabIndex = 5;
            this.labelTimeT1.Text = "0";
            // 
            // labelTimeTt
            // 
            this.labelTimeTt.AutoSize = true;
            this.labelTimeTt.Location = new System.Drawing.Point(92, 85);
            this.labelTimeTt.Name = "labelTimeTt";
            this.labelTimeTt.Size = new System.Drawing.Size(13, 13);
            this.labelTimeTt.TabIndex = 6;
            this.labelTimeTt.Text = "0";
            // 
            // labelIndexI
            // 
            this.labelIndexI.AutoSize = true;
            this.labelIndexI.Location = new System.Drawing.Point(92, 124);
            this.labelIndexI.Name = "labelIndexI";
            this.labelIndexI.Size = new System.Drawing.Size(13, 13);
            this.labelIndexI.TabIndex = 7;
            this.labelIndexI.Text = "0";
            // 
            // Form4_Main
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(435, 344);
            this.Controls.Add(this.labelIndexI);
            this.Controls.Add(this.labelTimeTt);
            this.Controls.Add(this.labelTimeT1);
            this.Controls.Add(this.labelGainK);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Name = "Form4_Main";
            this.Text = "Identificação Parametros";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label labelGainK;
        private System.Windows.Forms.Label labelTimeT1;
        private System.Windows.Forms.Label labelTimeTt;
        private System.Windows.Forms.Label labelIndexI;
    }
}