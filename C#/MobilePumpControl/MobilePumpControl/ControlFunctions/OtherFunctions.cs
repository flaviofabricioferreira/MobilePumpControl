using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MobilePumpControl.ControlFunctions
{
    class OtherFunctions
    {
        public static List<double> multiplyPolys(List<double> poly1, List<double> poly2)
        {

            int poly1Size = poly1.Count;
            int poly2Size = poly2.Count;

            List<double> polyResult = OtherFunctions.zeros(poly1Size + poly2Size - 1);
            

            for (int i = 0; i < poly1Size; ++i)
            {
                for (int j = 0; j < poly2Size; ++j)
                {
                    //polyResult.set((i + j), (polyResult.get(i + j) + (poly1.get(i) * poly2.get(j))));
                    polyResult[i + j] =  (polyResult[i + j] + (poly1[i] * poly2[j]));
                }
            }

            return polyResult;

        }

        public static List<double> zeros(int size){
            List<double> list = new List<double>();
            for (int i = 0; i < size; i++)
            {
                list.Add(0.0);
            }
            return list;
        }


        /**
        *Determine the mean of a number array
        *@param name="numbers" The Array of numbers 
        */
        public static double meanCalcFromArray(List<double> numbers)
        {

            double sum = 0;

            for (int i = 0; i < numbers.Count; i++)
                sum = sum + numbers[i];

            double average = sum / numbers.Count;

            return average;
        }

        public static double minCalcFromArray(List<double> numbers)
        {

            double min = numbers[0];

            for (int i = 0; i < numbers.Count; i++)
            {
                if (numbers[i] < min)
                {
                    min = numbers[i];
                }
            }

            return min;
        }

        public static double maxCalcFromArray(List<double> numbers)
        {

            double max = numbers[0];

            for (int i = 0; i < numbers.Count; i++)
            {
                if (numbers[i] > max)
                {
                    max = numbers[i];
                }
            }

            return max;
        }


    }
}
