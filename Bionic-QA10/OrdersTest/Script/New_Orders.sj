// Create new orders function
function NewOrders()           
{
  // Define variables 
  var product = Aliases.OrderForm.ProductNames;
  var quantity = Aliases.OrderForm.Quantity;
  var price = Aliases.OrderForm.Price;
  var discount = Aliases.OrderForm.Discount;
  var total = Aliases.OrderForm.Total;
  var order_date = Aliases.OrderForm.Date;
  var customer_name = Aliases.OrderForm.CustomerName;
  var street = Aliases.OrderForm.Street;
  var state = Aliases.OrderForm.State;
  var city = Aliases.OrderForm.City;
  var zip = Aliases.OrderForm.Zip;
  var visa = Aliases.OrderForm.Visa;
  var master_card = Aliases.OrderForm.MasterCard;
  var american_express = Aliases.OrderForm.AE;
  var card_number = Aliases.OrderForm.CardNo;
  var expiration_date = Aliases.OrderForm.ExpDate;   
  var drv = DDT.ExcelDriver(Project.Path + "\\Stores\\Files\\data.xls", "data", false); // create driver for Excel file reading
  var row = 0;                                                        // counter
  
  Log.AppendFolder("New orders");
   
  while (!DDT.CurrentDriver.EOF())                                    // create orders according to rows number in data.xls file
  { 
    row = row + 1; 
    Log.AppendFolder("Order " + row + " creation"); // create folder in Log and place logs into it
    
    //Log.PushLogFolder(Log.CreateFolder("111"));     
    NameMapping.sys.Orders.mainForm.MainMenu.Click("Orders|New order...");  // select "New order" in top menu 
     
    // Clear existing values from the inputs  
    price.Clear(); 
    discount.Clear();
    total.Clear();
    customer_name.Clear();  
    street.Clear();
    state.Clear();
    city.Clear();
    zip.Clear();
    card_number.Clear();   

    // Enter testing values from driver structure (data.xls file) into inputs   
    product.ClickItem(drv.Value("Product"));
    quantity.wValue = drv.Value("Quantity");
    price.Keys(drv.Value("Price"));
    discount.Keys(drv.Value("Discount"));
    total.Keys(drv.Value("Total"));
    order_date.wDate = drv.Value("Date");
    customer_name.Keys(drv.Value("Customer Name"));
    street.Keys(drv.Value("Street"));
    state.Keys(drv.Value("State"));
    city.Keys(drv.Value("City"));
    zip.Keys(drv.Value("Zip"));
  
    // Choose radio button depending on data in data.xls in "Card" column
    switch (drv.Value("Card"))
    {
    case "Visa":
      visa.Click();
      break;
    case "MasterCard":
      master_card.Click();
      break;
    case "American Express":
      american_express.Click();
      break;
    }
  
    card_number.Keys(drv.Value("Card No"));
    expiration_date.wDate = drv.Value("Expiration Date"); 

    Aliases.OrderForm.ButtonOK.ClickButton();   // click confirmation "Ok" button 
    
    // Compare entered value and value in the orders list 
    aqObject.CompareProperty(Aliases.OrdersView.wSelectedItems, cmpEqual, drv.Value("Customer Name"), true);
    drv.Next();               // choose next row with data in data.xls  
    Log.PopLogFolder();       // step up from current Log folder
  }
  
  DDT.CloseDriver(drv.Name);  // close driver
  Log.PopLogFolder();
}