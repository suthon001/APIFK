/// <summary>
/// TableExtension FK Vendor Ledger Entry (ID 60067) extends Record Vendor Ledger Entry.
/// </summary>
tableextension 60067 "FK Vendor Ledger Entry" extends "Vendor Ledger Entry"
{
    fields
    {
        field(60050; "TPP Vend. Bill. Rem. Amt.(LCY)"; Decimal)
        {
            Caption = 'Vend. Bill. Rem. Amt. (LCY)';
            DataClassification = CustomerContent;

        }
        field(60051; "TPP Vend. Bill. Amount (LCY)"; Decimal)
        {
            Caption = 'Vend. Bill. Amount (LCY)';
            FieldClass = FlowField;
            CalcFormula = - Sum("TPP Billing - Receipt Line"."TPP Amount (LCY)" WHERE("TPP Document Type" = FILTER("P. Billing"), "TPP Vendor Entry No." = FIELD("Entry No.")));
            Editable = false;


        }
        field(60052; "TPP Vend. Billing Open"; Boolean)
        {
            Caption = 'Vend. Billing Open';
            DataClassification = CustomerContent;
        }
    }
}
