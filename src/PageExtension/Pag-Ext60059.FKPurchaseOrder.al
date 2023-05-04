/// <summary>
/// PageExtension FK Purchase Order (ID 60059) extends Record Purchase Order.
/// </summary>
pageextension 60059 "FK Purchase Order" extends "Purchase Order"
{
    layout
    {
        addlast(General)
        {
            field("Vendor No. Intranet"; Rec."Vendor No. Intranet")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
            field("Ref. GR No. Intranet"; Rec."Ref. GR No. Intranet")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
        }
    }
}
