pageextension 60070 "FK Vendor Templ. Card" extends "Vendor Templ. Card"
{
    layout
    {
        addlast(Template)
        {
            field("Vendor Direct"; Rec."Vendor Direct")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies value of the field.';
            }
        }
    }
}
