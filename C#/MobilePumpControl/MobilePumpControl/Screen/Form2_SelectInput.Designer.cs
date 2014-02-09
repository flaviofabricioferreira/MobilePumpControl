namespace MobilePumpControl.Screen
{
    partial class Form2InputSelection
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
            this.button1 = new System.Windows.Forms.Button();
            this.buttonInputNext = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(29, 30);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(80, 23);
            this.button1.TabIndex = 4;
            this.button1.Text = "Importar Sinal";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // buttonInputNext
            // 
            this.buttonInputNext.Enabled = false;
            this.buttonInputNext.Location = new System.Drawing.Point(197, 226);
            this.buttonInputNext.Name = "buttonInputNext";
            this.buttonInputNext.Size = new System.Drawing.Size(75, 23);
            this.buttonInputNext.TabIndex = 8;
            this.buttonInputNext.Text = "next";
            this.buttonInputNext.UseVisualStyleBackColor = true;
            this.buttonInputNext.Click += new System.EventHandler(this.button5_Click);
            // 
            // Form2InputSelection
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(284, 261);
            this.Controls.Add(this.buttonInputNext);
            this.Controls.Add(this.button1);
            this.Name = "Form2InputSelection";
            this.Text = "Input Signal Selection";
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.Button buttonInputNext;
    }
}