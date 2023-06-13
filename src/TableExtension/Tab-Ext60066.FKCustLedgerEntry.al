/// <summary>
/// TableExtension FK Cust. Ledger Entry (ID 60066) extends Record Cust. Ledger Entry.
/// </summary>
tableextension 60066 "FK Cust. Ledger Entry" extends "Cust. Ledger Entry"
{
    fields
    {
        field(60050; "TPP Cust. Rec. Rem. Amt. (LCY)"; Decimal)
        {
            Caption = 'Cust. Rec. Rem. Amt. (LCY)';
            DataClassification = SystemMetadata;

        }
        field(60051; "TPP Cust. Rec. Amount (LCY)"; Decimal)
        {
            Caption = 'Cust. Rec. Amount (LCY)';
            FieldClass = FlowField;
            CalcFormula = Sum("TPP Billing - Receipt Line"."TPP Amount (LCY)" WHERE("TPP Document Type" = FILTER(Receipt), "TPP Cust. Entry No." = FIELD("Entry No.")));
            Editable = false;
        }
        field(60052; "TPP Cust. Rec. Open"; Boolean) { Caption = 'Cust. Rec. Open'; DataClassification = SystemMetadata; }
        field(60053; "TPP Cust. Bill. Rem. Amt.(LCY)"; Decimal) { Caption = 'Cust. Billing Rem. Amt. (LCY)'; DataClassification = SystemMetadata; }
        field(60054; "TPP Cust. Billing Amount (LCY)"; Decimal)
        {
            Caption = 'Cust. Billing Amount (LCY)';
            FieldClass = FlowField;
            CalcFormula = Sum("TPP Billing - Receipt Line"."TPP Amount (LCY)" WHERE("TPP Document Type" = FILTER(Billing), "TPP Cust. Entry No." = FIELD("Entry No.")));
            Editable = false;
        }
        field(60055; "TPP Cust. Billing Open"; Boolean)
        {
            Caption = 'Cust. Billing Open';
            DataClassification = SystemMetadata;
        }
    }
}
