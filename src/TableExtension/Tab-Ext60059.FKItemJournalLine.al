tableextension 60059 "FK Item Journal Line" extends "Item Journal Line"
{
    fields
    {
        field(60050; "Temp. Lot No."; Code[50])
        {
            Caption = 'Temp. Lot No.';
            DataClassification = ToBeClassified;
        }
        field(60051; "Temp. Expire Date"; date)
        {
            Caption = 'Temp. Expire Date';
            DataClassification = ToBeClassified;
        }
        field(60052; "Temp. New Lot No."; Code[50])
        {
            Caption = 'Temp. New Lot No.';
            DataClassification = ToBeClassified;
        }
        field(60053; "Document No. Series"; Code[20])
        {
            Caption = 'Document No. Series';
            DataClassification = ToBeClassified;
        }

    }
    procedure AssistEdit(OldItemJournalLine: Record "Item Journal Line"): Boolean
    var
        ItemJournalLine: Record "Item Journal Line";
        ItemJournalBatch: Record "Item Journal Batch";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin

        ItemJournalLine.COPY(Rec);
        ItemJournalBatch.GET(ItemJournalLine."Journal Template Name", ItemJournalLine."Journal Batch Name");
        ItemJournalBatch.TESTFIELD("Document No. Series");
        IF NoSeriesMgt.SelectSeries(ItemJournalBatch."Document No. Series", OldItemJournalLine."Document No. Series",
            ItemJournalLine."Document No. Series") THEN BEGIN
            NoSeriesMgt.SetSeries(ItemJournalLine."Document No.");
            Rec := ItemJournalLine;
            EXIT(TRUE);
        END;
    end;
}

