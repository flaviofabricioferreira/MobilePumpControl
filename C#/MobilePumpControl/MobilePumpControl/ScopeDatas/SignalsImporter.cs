using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MobilePumpControl.ScopeDatas
{
    class SignalsImporter
    {
        public static double[] importSignal(String address) {

            string[] lines = System.IO.File.ReadAllLines(address);
            double[] signal = new double[lines.Length];

            for (int i = 0; i < lines.Length; i++)
            {
                lines[i].Replace(",", ".");
                signal[i] = Convert.ToDouble(lines[i]);
            }

            return signal;
        }
    }
}

