using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Timers;
using System.Windows.Threading;

namespace MyWPFApp
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
            Loaded += MainWindow_Loaded;
            
        }

        private void MainWindow_Loaded(object sender, RoutedEventArgs e)
        {
            DispatcherTimer timer = new DispatcherTimer();
            timer.Tick += Timer_Tick;
            timer.Interval = TimeSpan.FromMilliseconds( 1000 );
            timer.Start();
        }

        private void Timer_Tick(object? sender, EventArgs e)
        //  void Timer_Elapsed(object sender, ElapsedEventArgs e)
        {
            Title = e.ToString();
        }

        private void onMouseEnter(object sender, MouseEventArgs e)
        {
            var obj = this.FindName("my_rectangle");
            Title =  String.Format("{0} - {1}", my_rectangle.Name, obj.ToString());
            //Title = obj.GetType().FullName;

            if (e.LeftButton == MouseButtonState.Pressed)
            {

                Storyboard? sb = this.FindResource("Storyboard2") as Storyboard;
                if (null != sb)
                {
                    sb.Begin();
                }
            }
        }

        private void cmdStart_Click(object sender, RoutedEventArgs e)
        {
            Title = "Click to start...";
        }
        private void cmdPause_Click(object sender, RoutedEventArgs e)
        {
            Title = "Click to pause...";
        }
    }
}
