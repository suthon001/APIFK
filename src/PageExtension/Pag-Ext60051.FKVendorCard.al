/// <summary>
/// PageExtension FK Vendor Card (ID 60051) extends Record Vendor Card.
/// </summary>
pageextension 60051 "FK Vendor Card" extends "Vendor Card"
{
    layout
    {
        addafter(General)
        {
            group(FKInterface)
            {
                Caption = 'Interface';
                ShowCaption = false;
                field("Supplier Eng Name"; Rec."Supplier Eng Name")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';

                }
                field("Vendor No. Intranet"; Rec."Vendor No. Intranet")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field(User_Name; Rec.User_Name)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("VAT registration supplier"; Rec."VAT registration supplier")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("Company Type"; Rec."Company Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("Vendor Direct"; Rec."Vendor Direct")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }

                field("Billing Address"; Rec."Billing Address")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("Billing Address 2"; Rec."Billing Address 2")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("Billing City"; Rec."Billing City")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("Billing Post Code"; Rec."Billing Post Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
                field("Billing Region Code"; Rec."Billing Region Code")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies value of the field.';
                }
            }
        }
    }
}