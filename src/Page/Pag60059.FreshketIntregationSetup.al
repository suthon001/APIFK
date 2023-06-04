page 60059 "Freshket Intregation Setup"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Freshket Intregation Setup';
    PageType = Card;
    SourceTable = "Freshket Intregation Setup";
    DeleteAllowed = false;
    InsertAllowed = false;
    UsageCategory = Administration;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("FK URL"; Rec."FK URL")
                {
                    ToolTip = 'Specifies the value of the URL field.';
                    ApplicationArea = all;
                }
                field("FK UserName"; Rec."FK UserName")
                {
                    ToolTip = 'Specifies the value of the UserName field.';
                    ApplicationArea = all;
                }
                field("FK Password"; Rec."FK Password")
                {
                    ToolTip = 'Specifies the value of the Password field.';
                    ExtendedDatatype = Masked;
                    ApplicationArea = all;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
