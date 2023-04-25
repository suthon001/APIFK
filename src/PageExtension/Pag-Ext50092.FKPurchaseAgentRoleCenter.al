/// <summary>
/// PageExtension FK Purchase Agent Role Center (ID 50092) extends Record Purchasing Agent Role Center.
/// </summary>
pageextension 50092 "FK Purchase Agent Role Center" extends "Purchasing Agent Role Center"
{
    actions
    {
        addafter("Purchase &Order")
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
