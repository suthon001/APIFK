/// <summary>
/// PageExtension FK Order Processor Role Center (ID 60053) extends Record Order Processor Role Center.
/// </summary>
pageextension 60053 "FK Order Processor Role Center" extends "Order Processor Role Center"
{
    actions
    {
        addafter("Purchase Orders")
        {
            action("GoodReceiptNote")
            {
                ApplicationArea = Suite;
                Caption = 'Good Receipt Note';
                Image = Document;
                RunObject = Page "FK Good ReceiptNote List";
                ToolTip = 'Good ReceiptNote List';
            }
        }
    }
}
