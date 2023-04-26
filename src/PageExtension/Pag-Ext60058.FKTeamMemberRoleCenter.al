/// <summary>
/// PageExtension FK Team Member Role Center (ID 60058) extends Record Team Member Role Center.
/// </summary>
pageextension 60058 "FK Team Member Role Center" extends "Team Member Role Center"
{
    actions
    {
        addafter("<Page Purchase Orders>")
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
